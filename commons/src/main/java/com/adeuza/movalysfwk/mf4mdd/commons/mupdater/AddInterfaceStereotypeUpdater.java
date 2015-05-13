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
package com.adeuza.movalysfwk.mf4mdd.commons.mupdater;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.a2a.adjava.AdjavaException;
import com.a2a.adjava.messages.MessageHandler;
import com.a2a.adjava.mupdater.AbstractMUpdater;
import com.a2a.adjava.mupdater.MUpdater;
import com.a2a.adjava.umlupdater.AbstractUmlUpdater;
import com.a2a.adjava.xmodele.IDomain;
import com.a2a.adjava.xmodele.IModelDictionary;
import com.a2a.adjava.xmodele.IModelFactory;
import com.a2a.adjava.xmodele.MEntityImpl;
import com.a2a.adjava.xmodele.MLinkedInterface;
import com.a2a.adjava.xmodele.MStereotype;

/**
 * <p>Permet d'ajouter les interfaces venant des stéréotypes sur les interfaces des beans.</p>
 * 
 * <p>Copyright (c) 2009</p>
 * <p>Company: Adeuza</p>
 * 
 * @see AbstractUmlUpdater
 * 
 * @since 2.5
 * @author mmadigand
 * 
 */
public class AddInterfaceStereotypeUpdater extends AbstractMUpdater {

	/**
	 * Logger for this class
	 */
	private static final Logger log = LoggerFactory.getLogger(AddInterfaceStereotypeUpdater.class);

	/**
	 * {@inheritDoc}
	 * 
	 * @see MUpdater#execute(com.a2a.adjava.project.ProjectConfig, com.a2a.adjava.uml.UmlModele, java.util.Map)
	 */
	@Override
	public void execute(IDomain<IModelDictionary, IModelFactory> p_oDomain, Map<String, ?> p_oGlobalSession) throws Exception {
		log.debug("> AddInterfaceStereotypeUpdater.execute()");

		IModelDictionary oModeleDictionnary = p_oDomain.getDictionnary();

		String sInterfaceName = null;
		String sStereotypeName = null;
		String sPackageName = null;

		String sEntityClassName = this.getParametersMap().get("Entity");
		if ( sEntityClassName == null || sEntityClassName.isEmpty()) {
			throw new AdjavaException("Parameter 'Entity' is not defined on UmlUpdater AddInterfaceStereotypeUpdater for domain {}", p_oDomain.getName());
		}
		String sEntityShortName = sEntityClassName.substring(sEntityClassName.lastIndexOf('.')+1);
		
		String sPersistableEntityClassName = this.getParametersMap().get("PersistableEntity");
		if ( sPersistableEntityClassName == null || sPersistableEntityClassName.isEmpty()) {
			throw new AdjavaException("Parameter 'PersistableEntity' is not defined on UmlUpdater AddInterfaceStereotypeUpdater for domain {}",
					p_oDomain.getName());
		}
		String sPersistableEntityShortName = sPersistableEntityClassName.substring(sPersistableEntityClassName.lastIndexOf('.')+1);

		String sCustomizableEntityClassName = this.getParametersMap().get("CustomizableEntity");
		if ( sCustomizableEntityClassName == null || sCustomizableEntityClassName.isEmpty()) {
			throw new AdjavaException("Parameter 'CustomizableEntity' is not defined on UmlUpdater AddInterfaceStereotypeUpdater for domain {}",
					p_oDomain.getName());
		}
		String sCustomizableEntityShortName = sCustomizableEntityClassName.substring(sCustomizableEntityClassName.lastIndexOf('.')+1);

		
		
		for (MEntityImpl oMClass : oModeleDictionnary.getAllEntities()) {
			List<MStereotype> oStereoTypeList = oMClass.getStereotypes();
			
			List<MStereotype> listInterfaceMStereotype = new ArrayList<MStereotype>();
			for (MStereotype oMStereotype : oStereoTypeList) {
				sStereotypeName = oMStereotype.getName();
				if (sStereotypeName.toLowerCase().startsWith("interface")) {
					listInterfaceMStereotype.add(oMStereotype);
				}
			}
			if (listInterfaceMStereotype.isEmpty()) {
				if ( oMClass.isTransient()) {
					oMClass.getMasterInterface().addLinkedInterface(new MLinkedInterface(sEntityShortName, sEntityClassName));
				}
				else if (oMClass.isCustomizable()) {
					oMClass.getMasterInterface().addLinkedInterface(new MLinkedInterface(sCustomizableEntityShortName, sCustomizableEntityClassName));
				}
				else {
					oMClass.getMasterInterface().addLinkedInterface(new MLinkedInterface(sPersistableEntityShortName, sPersistableEntityClassName));
				}
			} else {
				for (MStereotype oMStereotype : listInterfaceMStereotype) {
					sStereotypeName = oMStereotype.getName();
					if (sStereotypeName.toLowerCase().startsWith("interface")) {
						sInterfaceName = sStereotypeName.substring(sStereotypeName.toLowerCase().indexOf("interface") + "interface".length());
						sPackageName = this.getParametersMap().get(sInterfaceName);
						if (sPackageName == null) {
							MessageHandler.getInstance().addError("Le stereotype 'interface','" + sInterfaceName + "' n'est pas paramètré.");
						} else {
							oMClass.getMasterInterface().addLinkedInterface(new MLinkedInterface(sInterfaceName, sPackageName));
						}
					}
				}
			}
		}

		log.debug("< AddInterfaceStereotypeUpdater.execute()");
	}
}
