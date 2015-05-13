/**
 * Copyright (C) 2010 Sopra Steria Group (movalys.support@soprasteria.com)
 *
 * This file is part of Movalys MDK.
 * Movalys MDK is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 * Movalys MDK is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU Lesser General Public License for more details.
 * You should have received a copy of the GNU Lesser General Public License
 * along with Movalys MDK. If not, see <http://www.gnu.org/licenses/>.
 */
package com.adeuza.movalysfwk.mf4mdd.commons.generator;

import java.io.File;
import java.util.ArrayList;
import java.util.List;

import org.apache.commons.io.FileUtils;
import org.dom4j.Document;
import org.dom4j.DocumentHelper;
import org.dom4j.Element;
import org.dom4j.io.DocumentSource;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.a2a.adjava.codeformatter.FormatOptions;
import com.a2a.adjava.codeformatter.GeneratedFile;
import com.a2a.adjava.generator.core.concat.AbstractConcatGenerator;
import com.a2a.adjava.generators.DomainGeneratorContext;
import com.a2a.adjava.utils.Chrono;
import com.a2a.adjava.xmodele.IModelDictionary;
import com.a2a.adjava.xmodele.MAssociation;
import com.a2a.adjava.xmodele.MAssociation.AssociationType;
import com.a2a.adjava.xmodele.MAssociationManyToOne;
import com.a2a.adjava.xmodele.MAssociationOneToOne;
import com.a2a.adjava.xmodele.MEntityImpl;
import com.a2a.adjava.xmodele.MJoinEntityImpl;
import com.a2a.adjava.xmodele.XProject;

/**
 * <p>
 * 	Genere le csv correspondant au modèle afin qu'il soit importé dans le fichier d'injection de donnée.
 * </p>
 * 
 * <p>Copyright (c) 2009</p>
 * <p>Company: Adeuza</p>
 *
 * @author fbourlieux
 * @param <D>
 * @since MF-Annapurna
 */
public class PojoCsvGenerator extends AbstractConcatGenerator {

	/** Logger for this class */
	private static final Logger log = LoggerFactory.getLogger(PojoCsvGenerator.class);
	
	/** tools directory where the file should be generated */
	private static final String TOOLS_DIR = "tools";
	
	/** Compteur de boucles pour ordonner les classes */
	private int iCompteurBoucles = 0 ;
	
	/** Nombre maximum de boucles pour ordonner les classes */
	private static final int NB_MAX_BOUCLE = 20 ;
	
	/** Indice du compteur de boucles à partir duquel on tolère les associations facultatives */
	private static final int INDEX_BOUCLE_WITH_NOTNULL = 10 ;
	
	/**
	 * {@inheritDoc}
	 */
	@Override
	public void genere(XProject p_oProject, DomainGeneratorContext p_oGeneratorContext) throws Exception {
		log.debug("> PojoCsvGenerator.genere");
		Chrono oChrono = new Chrono(true);
		
		IModelDictionary oDictionnary = p_oProject.getDomain().getDictionnary();
		
		String sPojoFile = TOOLS_DIR + "/" + "adjava-generated-model.csv";
		File oFile = new File(sPojoFile);
		if (oFile.exists()) {
			FileUtils.deleteQuietly(oFile);
		}
		
		Element xRoot = DocumentHelper.createElement("diagram");
		Document xDoc = DocumentHelper.createDocument(xRoot);
		if (p_oProject.getDomain().getSchema()!=null){ // schema facultatif : sur iOS le schema n'est pas généré
			xRoot.add(p_oProject.getDomain().getSchema().toXml());
		}
		
		Element xClasses = xRoot.addElement("classes"); 
		this.addOrderedClasses(xClasses, oDictionnary,null) ;
		
		for (MJoinEntityImpl oEntity : oDictionnary.getAllJoinClasses()) {
			xClasses.add(oEntity.toXml());
		}
		log.debug("  generation du fichier: {} ", sPojoFile);
		this.doTransformToFile(new DocumentSource(xDoc), "pojo-csv.xsl", new GeneratedFile<FormatOptions>(sPojoFile), p_oProject, p_oGeneratorContext, false, false);

		log.debug("< PojoCsvGenerator.genere: {}", oChrono.stopAndDisplay());
	}
	
	/**
	 * Ajoute dans l'élément XML fourni toutes les classes de façon ordonnée pour qu'une classe liée à une autre
	 * soit ajoutée après la classe liée 
	 * @param p_xClasses élément contenant toutes les classes
	 * @param p_oDictionnary dictionnaire des classes du modèle
	 */
	protected void addOrderedClasses(Element p_xClasses , IModelDictionary p_oDictionnary , List<String> listClassesAlreadyAdded ){
		
		if ( listClassesAlreadyAdded == null ){
			 listClassesAlreadyAdded = new ArrayList<String>() ;	
		}
		for (MEntityImpl oEntity : p_oDictionnary.getAllEntities()) {
			
			if ( ! listClassesAlreadyAdded.contains(oEntity.getEntityName() )
					&& ( oEntity.getAssociations().isEmpty() 
							|| this.isAssociatedClassesAlreadyAdded(oEntity, listClassesAlreadyAdded) )
			    ) {
				listClassesAlreadyAdded.add( oEntity.getEntityName() );
				log.debug("  add entity : {} ", oEntity.getEntityName());
				p_xClasses.add(oEntity.toXml());
			}
		}
		
		// on reboucle si toutes les classes n'ont pas été ajoutées
		if ( listClassesAlreadyAdded.size() < p_oDictionnary.getAllEntities().size() 
				&& iCompteurBoucles < NB_MAX_BOUCLE  ){
			iCompteurBoucles++; 
			log.debug("  passage : {} ", iCompteurBoucles );
			this.addOrderedClasses(p_xClasses, p_oDictionnary, listClassesAlreadyAdded) ;
		}else if ( iCompteurBoucles == NB_MAX_BOUCLE ) {
			// on a passé le max de boucles on  ajoute toutes les classes manquantes
			for (MEntityImpl oEntity : p_oDictionnary.getAllEntities()) {
				if ( ! listClassesAlreadyAdded.contains(oEntity.getEntityName() )) {
					listClassesAlreadyAdded.add( oEntity.getEntityName() );
					log.debug(" finally  add entity : {} ", oEntity.getEntityName());
					p_xClasses.add(oEntity.toXml());
				}
			}
		} else {
			// toutes les classes ont été ajoutées 1 seule fois
			log.debug("  {} classes ordered ", listClassesAlreadyAdded.size() );
		}
	}
	
	/**
	 * Vérifie si les associations (One-to-One avec relation owner et Many To One) liées à l'entité sont déjà insérées dans la liste
	 * A partir du INDEX_BOUCLE_WITH_NOTNULL eme passage on tolère les relations facultatives
	 * @param p_oEntity entité dont on regarde les associations
	 * @param p_listClassesAlreadyAdded listes des noms d'entités déjà ajoutées
	 * @return vrai si toutes les associations liées ont des classes déjà insérées dans la liste
	 * faux si une classe associée en One-to-One et Many To One n'a pas déjà été inséré 
	 */
	private boolean isAssociatedClassesAlreadyAdded(MEntityImpl p_oEntity , List<String> p_listClassesAlreadyAdded ){
		
		for ( MAssociation oAssoc : p_oEntity.getAssociations() ) {
			
			if ( oAssoc.getAssociationType() == AssociationType.ONE_TO_ONE && oAssoc.isRelationOwner() && !oAssoc.isTransient() ) {
				String sClassAssociated = null ;
				if ( oAssoc.getOppositeClass().getEntityName().equals( p_oEntity.getEntityName() ) ) {
					sClassAssociated = oAssoc.getRefClass().getEntityName() ;
				} else {
					sClassAssociated = oAssoc.getOppositeClass().getEntityName() ;
				}			
				
				if ( ! p_listClassesAlreadyAdded.contains( sClassAssociated ) ){ 
					// a partir du INDEX_BOUCLE_WITH_NOTNULL eme passage , on tolere les relations facultatives
					if ( iCompteurBoucles < INDEX_BOUCLE_WITH_NOTNULL || ((MAssociationOneToOne)oAssoc).isNotNull() ) {
						log.debug("  isAssociatedClassesAlreadyAdded ONE_TO_ONE false for : '{}' because of '{}'", p_oEntity.getEntityName() ,
							oAssoc.getRefClass().getEntityName() +" with " +oAssoc.getOppositeClass().getEntityName() );
						return false ;
					}
				}
			} else if ( oAssoc.getAssociationType() == AssociationType.MANY_TO_ONE ){
				if ( ! p_listClassesAlreadyAdded.contains( oAssoc.getRefClass().getEntityName() ) ){
					if ( iCompteurBoucles < INDEX_BOUCLE_WITH_NOTNULL || ((MAssociationManyToOne)oAssoc).isNotNull() ) {
						log.debug("  isAssociatedClassesAlreadyAdded MANY_TO_ONE false for : '{}' because of '{}' ", p_oEntity.getEntityName() ,
								oAssoc.getRefClass().getEntityName());
						return false ;
					}
				}
			}
			log.debug("  isAssociatedClassesAlreadyAdded found ( '{}' ) for ref : '{}' ", p_oEntity.getEntityName(), 
					oAssoc.getAssociationType() + " " + oAssoc.getRefClass().getEntityName() +" with "+oAssoc.getOppositeClass().getEntityName());
		}		
		log.debug("  isAssociatedClassesAlreadyAdded true for : '{}' ", p_oEntity.getEntityName());

		return true ;		
	}
}
