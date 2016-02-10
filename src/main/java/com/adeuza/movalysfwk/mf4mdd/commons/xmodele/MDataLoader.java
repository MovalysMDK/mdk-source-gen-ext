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
package com.adeuza.movalysfwk.mf4mdd.commons.xmodele;

import java.util.ArrayList;
import java.util.List;

import org.dom4j.Element;

import com.a2a.adjava.xmodele.MCascade;
import com.a2a.adjava.xmodele.MDaoInterface;
import com.a2a.adjava.xmodele.MEntityInterface;
import com.a2a.adjava.xmodele.MFactory;
import com.a2a.adjava.xmodele.MMethodSignature;
import com.a2a.adjava.xmodele.MPackage;
import com.a2a.adjava.xmodele.SClass;

/**
 * <p>Class that constructs the XML that will used to generate <code>DataLoader</code> implementations.</p>
 *
 * <p>Copyright (c) 2012</p>
 * <p>Company: Adeuza</p>
 *
 * @since MF-Baltoro
 */
public class MDataLoader extends SClass<MDataLoaderInterface,MMethodSignature> {

	private MDaoInterface loadDao;
	private List<MCascade> loadCascade = new ArrayList<MCascade>();
	private List<MEntityInterface> observedEntities = new ArrayList<MEntityInterface>();
	private MFactory factory;
	
	/**
	 * Construct a new <code>MDataLoader</code> object.
	 * @param p_sUmlName <code>SClass</code> name in the UML diagram
	 * @param p_sName <code>SClass</code> name
	 * @param p_oPackage <code>SClass</code> package
	 * @param p_oMDataLoaderInterface the interface of the DataLoader object 
	 */
	public MDataLoader(String p_sUmlName, String p_sName, MPackage p_oPackage, MDataLoaderInterface p_oMDataLoaderInterface) {
		super("dataloader-impl", p_sUmlName, p_sName, p_oPackage);
		this.setMasterInterface(p_oMDataLoaderInterface);
		this.addImport(this.getMasterInterface().getEntity().getMasterInterface().getFullName());
		this.observedEntities.add(p_oMDataLoaderInterface.getEntity().getMasterInterface());
	}
	
	/**
	 * Affecte la factory dans le cas d'un loadre transient.
	 * @param p_oFactory objet <code>MFactory</code>
	 */
	public void setFactory(MFactory p_oFactory){
		factory=p_oFactory;
	}
	
	/**
	 * Return a list of cascades used in the page.
	 * @return list of <code>MCascade</code> object
	 */
	public List<MCascade> getLoadCascade() {
		return loadCascade;
	}
	
	/**
	 * Add a list of <code>MCascade</code> the the cascade list.
	 * Note that if the inner list already contains a cascade, it'll not be added.
	 * @param p_listCascades the list of <code>MCascade</code> to add to the inner list
	 */
	public void addLoadCascade( List<MCascade> p_listCascades ) {
		
		if ( p_listCascades != null ) {
			for( MCascade oCascade : p_listCascades ) {
				if (!loadCascade.contains(oCascade)) {
					loadCascade.add(oCascade);
					this.addImport(oCascade.getTargetEntity().getMasterInterface().getFullName());
				}
			}
		}
	}
	
	/**
	 * add  an <code>MEntityInterface</code> the the inner list of <code>MEntityInterface</code>.
	 * @param p_oEntityInterface the <code>MEntityInterface</code> to add
	 */
	public void addObservedEntity( MEntityInterface p_oEntityInterface) {
		if ( !observedEntities.contains(p_oEntityInterface)) {
			observedEntities.add(p_oEntityInterface);
		}
	}
	
	/**
	 * Add a dao interface used to load data in the current screen.
	 * @param p_oLoadDao the dao to add to the inne list of dao.
	 */
	public void setLoadDao(MDaoInterface p_oLoadDao) {
		loadDao = p_oLoadDao;
		if ( loadDao != null ) {
			this.addImport(loadDao.getFullName());
		}
	}
	
	/**
	 * Get dao for loading
	 * @return dao for loading
	 */
	public MDaoInterface getLoadDao() {
		return this.loadDao;
	}

	/**
	 * {@inheritDoc}
	 */
	@Override
	protected void toXmlInsertBeforeDocumentation(Element p_xElement) {
		super.toXmlInsertBeforeDocumentation(p_xElement);
		p_xElement.add(this.getMasterInterface().toXml());

		Element xCascade =  p_xElement.addElement("cascades");
		for( MCascade oCascade : loadCascade) {
			xCascade.add(oCascade.toXml());
		}
		
		Element xObservedEntites =  p_xElement.addElement("observed-entities");
		for( MEntityInterface oMEntityInterface : observedEntities) {
			Element xEntity = xObservedEntites.addElement("entity");
			xEntity.addElement("name").setText(oMEntityInterface.getName());
			xEntity.addElement("full-name").setText(oMEntityInterface.getFullName());
		}
		
		if (loadDao != null ) {
			p_xElement.add(loadDao.toXml());
		}
		
		if (factory!=null){
			Element xFactory = p_xElement.addElement("entity-factory");
			xFactory.addElement("name").setText(factory.getMasterInterface().getName());
			xFactory.addElement("full-name").setText(factory.getMasterInterface().getFullName());
		}
		
	}
}
